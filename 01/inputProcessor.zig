const std = @import("std");

const Point = struct {
    first: u8,
    second: u8,
};

test "part one" {
    try std.testing.expect(processLine("1abc2") == 12);
    try std.testing.expect(processLine("pqr3stu8vwx") == 38);
    try std.testing.expect(processLine("a1b2c3d4e5f") == 15);
    try std.testing.expect(processLine("treb7uchet") == 77);
}

test "part two" {
    try std.testing.expect(processLine("one") == 11);
    try std.testing.expect(processLine("o2") == 22);
    try std.testing.expect(processLine("two1nine") == 29);
    try std.testing.expect(processLine("eightwothree") == 83);
    try std.testing.expect(processLine("abcone2threexyz") == 13);
    try std.testing.expect(processLine("xtwone3four") == 24);
    try std.testing.expect(processLine("4nineeightseven2") == 42);
    try std.testing.expect(processLine("zoneight234") == 14);
    try std.testing.expect(processLine("7pqrstsixteen") == 76);
}

pub fn setPoint(num: u8, point: *Point) void {
    if (0 == point.first) {
        point.first = num;
    }
    point.second = num;
}

pub fn processLine(line: []const u8) u8 {
    var point = Point {
        .first = 0,
        .second = 0,
    };

    for (0.., line) |i, letter| {
        if ((letter >= '0') and (letter <= '9')) {
            setPoint(letter - '0', &point);
        }

        switch(letter) {
            'o' => {
                if (std.mem.startsWith(u8, line[i..], "one")) {
                    setPoint(1, &point);
                }
            },
            't' => {
                if (std.mem.startsWith(u8, line[i..], "two")) {
                    setPoint(2, &point);
                } else if (std.mem.startsWith(u8, line[i..], "three")) {
                    setPoint(3, &point);
                }
            },
            'f' => {
                if (std.mem.startsWith(u8, line[i..], "four")) {
                    setPoint(4, &point);
                } else if (std.mem.startsWith(u8, line[i..], "five")) {
                    setPoint(5, &point);
                }
            },
            's' => {
                if (std.mem.startsWith(u8, line[i..], "six")) {
                    setPoint(6, &point);
                } else if (std.mem.startsWith(u8, line[i..], "seven")) {
                    setPoint(7, &point);
                }
            },
            'e' => {
                if (std.mem.startsWith(u8, line[i..], "eight")) {
                    setPoint(8, &point);
                }
            },
            'n' => {
                if (std.mem.startsWith(u8, line[i..], "nine")) {
                    setPoint(9, &point);
                }
            },
            else => {},
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