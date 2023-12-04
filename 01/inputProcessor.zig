const std = @import("std");

const Point = struct {
    first: u8,
    second: u8,
};

test "part one" {
    try std.testing.expect(processLine("1abc2") == 12);
}

pub fn processLine(line: []const u8) u8 {
    var point = Point {
        .first = 0,
        .second = 0,
    };

    for (line) |letter| {
        if ((letter >= '0') and (letter <= '9')) {
            if (0 == point.first) {
                point.first = letter - '0';
            }
            point.second = letter - '0';
        }
    }
    const calibrationValue: u8 = (point.first * 10) + point.second;
    return calibrationValue;
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
        const calibrationValue: u8 = processLine(line);
        sumTotal += calibrationValue;
        std.debug.print("{d}: {s}\n", .{calibrationValue, line});
    }
    std.debug.print("sumTotal: {d} for {d} lines\n", .{sumTotal, linesRead});
}