const std = @import("std");

/// Get the square of the length of a vector
pub fn sqlen(self: anytype) @TypeOf(self[0]) {
    return @reduce(std.builtin.ReduceOp.Add, self * self);
}

/// Get the length of a vector
pub fn len(self: anytype) @TypeOf(self[0]) {
    return @sqrt(sqlen(self));
}

/// Dot product of 2 vectors
pub fn dot(u: anytype, v: @TypeOf(u)) @TypeOf(u[0]) {
    return @reduce(std.builtin.ReduceOp.Add, u * v);
}

/// Cross product of 2 vectors
pub fn cross(u: anytype, v: @TypeOf(u)) @TypeOf(u) {
    return @Vector(3, @TypeOf(u[0])){
        u[1] * v[2] - u[2] * v[1],
        u[2] * v[0] - u[0] * v[2],
        u[0] * v[1] - u[1] * v[0],
    };
}

/// Write the value of a colour vector to the output stream, assuming ppm image
/// format.
pub fn write_colour(writer: *std.io.Writer, colour: anytype) !void {
    const r, const g, const b = colour;

    const ir: u8 = @intFromFloat(255.999 * r);
    const ig: u8 = @intFromFloat(255.999 * g);
    const ib: u8 = @intFromFloat(255.999 * b);

    try writer.print("{} {} {} \n", .{ ir, ig, ib });
}
