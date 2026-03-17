const std = @import("std");
const zig_raytrace = @import("zig_raytrace");

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();
    defer {
        const leak = gpa.deinit();
        if (leak == .leak) std.debug.print("Warn: Memory Leak", .{});
    }

    var args = try std.process.argsWithAllocator(allocator);

    // skip the process name
    _ = args.skip();

    // get a passed in file path
    var output: ?[:0]const u8 = null;
    if (args.next()) |arg| {
        output = arg;
    }

    // get the output file writer
    var output_file = if (output) |name|
        try std.fs.cwd().createFileZ(name, .{})
    else
        std.fs.File.stdout();
    var output_buffer: [4096]u8 = undefined;
    var writer = output_file.writer(&output_buffer);
    defer writer.end() catch {
        std.debug.panic("Error: Unable to complete file write", .{});
    };

    // get the log file writer
    var log_buffer: [4096]u8 = undefined;
    var log = std.fs.File.stderr().writer(&log_buffer);

    try zig_raytrace.rayTrace(f32, .{
        .file = &writer.interface,
        .log = &log.interface,
    });
}
