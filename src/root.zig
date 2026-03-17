const std = @import("std");
const v = @import("vector.zig");

pub const Config = struct {
    file: *std.io.Writer,
    log: *std.io.Writer,
};

/// Run the ray tracer!
pub fn rayTrace(Float: type, config: Config) !void {
    const width = 256;
    const height = 256;

    try config.file.print("P3\n{} {}\n255\n", .{ width, height });

    for (0..height) |j| {
        try config.log.print("\rScanlines remaining: {}  ", .{height - j});

        for (0..width) |i| {
            const r: Float = @as(Float, @floatFromInt(i)) / @as(Float, @floatFromInt(width - 1));
            const g: Float = @as(Float, @floatFromInt(j)) / @as(Float, @floatFromInt(height - 1));
            const b: Float = 0.0;

            try v.write_colour(config.file, @Vector(3, Float){ r, g, b });
        }
    }

    try config.log.print("\rDone                      \n", .{});
}
