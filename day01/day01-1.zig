const std = @import("std");
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

const nextLine = @import("lib.zig").nextLine;

pub fn main() !void {
    const filename = "input.txt";

    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var most_calories: i32 = 0;
    var current_elf_calories: i32 = 0;
    const buffer: [16]u8 = undefined;
    while (try nextLine(file.reader(), &buffer)) |line| {
        if (line.len == 0) {
            // This elf's inventory is done
            if (current_elf_calories > most_calories) {
                most_calories = current_elf_calories;
            }
            current_elf_calories = 0;
            continue;
        }
        const calories = try parseInt(i32, line, 10);
        current_elf_calories += calories;
    }

    print("The most calories carried by a single elf is {d} calories.\n", .{most_calories});
}
