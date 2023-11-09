const std = @import("std");

/// Removes all leading and trailing whitespace from `string`.
///
/// A whitespace character is one of the following:
/// - Space
/// - Tab (\t)
/// - Carriage return (\r)
/// - Line feed / Unix newline (\n)
pub fn trimWhitespace(string: []u8) []u8 {
    return std.mem.trim(u8, string, " \t\r\n");
}

/// Reads the file reader line-by-line, returning each line on each successive call.
///
/// Mostly a re-implementation for the deprecated `std.io.Reader.readUntilDelimiterOrEof`.
pub fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    var fbs = std.io.fixedBufferStream(buffer);
    reader.streamUntilDelimiter(fbs.writer(), '\n', fbs.buffer.len) catch |err| switch (err) {
        error.EndOfStream => if (fbs.getWritten().len == 0) {
            return null;
        },
        else => |e| return e,
    };
    const line = fbs.getWritten();

    // Trim windows-only end-of-line characters
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    }
    return line;
}
