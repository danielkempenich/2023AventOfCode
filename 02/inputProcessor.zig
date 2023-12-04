const std = @import("std");

const GameResult = enum {
    possible,
    notPossible,
};

const GameRecord = struct {
    gameNumber: u32,
    gameResult: GameResult,
};

const Round = struct {
    blue: u32,
    red: u32,
    green: u32,

    pub fn setValue(round: *Round, color: []const u8, number: u32) void {
        if (std.mem.eql(u8, color, "blue")) {
            round.blue = number;
        } else if (std.mem.eql(u8, color, "red")) {
            round.red = number;
        } else if (std.mem.eql(u8, color, "green")) {
            round.green = number;
        }
    }
};

test "part one" {
    try std.testing.expect(std.meta.eql(processLine("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"), GameRecord{ .gameNumber = 1, .gameResult = GameResult.possible }));
    try std.testing.expect(std.meta.eql(processLine("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"), GameRecord{ .gameNumber = 2, .gameResult = GameResult.possible }));
    try std.testing.expect(std.meta.eql(processLine("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"), GameRecord{ .gameNumber = 3, .gameResult = GameResult.notPossible }));
    try std.testing.expect(std.meta.eql(processLine("Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"), GameRecord{ .gameNumber = 4, .gameResult = GameResult.notPossible }));
    try std.testing.expect(std.meta.eql(processLine("Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"), GameRecord{ .gameNumber = 5, .gameResult = GameResult.possible }));
}

pub fn processLine(line: []const u8) GameRecord {
    var gameRecord: GameRecord = GameRecord{ .gameNumber = 0, .gameResult = GameResult.possible };
    var pos: u32 = 0;

    const roundUpperLimit = Round{ .blue = 14, .red = 12, .green = 13 };

    //std.debug.print("line: {s}\n", .{line});

    std.debug.assert(std.mem.startsWith(u8, line, "Game "));
    pos += 5;

    var tokenIterator = std.mem.tokenizeAny(u8, line[pos..], ":");

    gameRecord.gameNumber = std.fmt.parseInt(u32, tokenIterator.next().?, 10) catch unreachable;

    const gamesSlice = tokenIterator.next().?;
    tokenIterator = std.mem.tokenizeAny(u8, gamesSlice, ";");
    while (tokenIterator.next()) |gameSlice| {
        //std.debug.print("\tgameSlice {s}\n", .{gameSlice});
        var round: Round = Round{ .blue = 0, .red = 0, .green = 0 };
        var gameSliceTokenIterator = std.mem.tokenizeAny(u8, gameSlice, " ,");
        // Tokens should come in sets of 2, number followed by color
        while (gameSliceTokenIterator.next()) |numberString| {
            const number = std.fmt.parseInt(u8, numberString, 10) catch unreachable;
            const color = gameSliceTokenIterator.next();
            round.setValue(color.?, number);
        }

        if ((round.blue > roundUpperLimit.blue) or
            (round.red > roundUpperLimit.red) or
            (round.green > roundUpperLimit.green))
        {
            gameRecord.gameResult = GameResult.notPossible;
            break;
        }
    }

    //std.debug.print("\tFound: {d} {s}\n", .{ gameRecord.gameNumber, @tagName(gameRecord.gameResult) });
    return gameRecord;
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var buf: [1024]u8 = undefined;
    var sumTotal: u32 = 0;
    var linesRead: u32 = 0;
    while (try inStream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        linesRead += 1;
        const gameRecord: GameRecord = processLine(line);
        std.debug.print("{d} {s}: {s}\n", .{ gameRecord.gameNumber, @tagName(gameRecord.gameResult), line });
        switch (gameRecord.gameResult) {
            GameResult.possible => {
                sumTotal += gameRecord.gameNumber;
            },
            GameResult.notPossible => {},
        }
    }
    std.debug.print("sumTotal: {d} for {d} lines\n", .{ sumTotal, linesRead });
}
