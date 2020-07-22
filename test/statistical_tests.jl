using AbstractPlotting, StatsBase

using Random: seed!
using GeometryBasics: FRect2D

seed!(0)

@testset "crossbar" begin
    p = crossbar(1, 3, 2, 4)
    @test p.plots[end] isa CrossBar
    @test p.plots[end].plots[1] isa Poly
    @test p.plots[end].plots[1][1][] == [FRect2D(Float32[0.6, 2.0], Float32[0.8, 2.0]),]
    @test p.plots[end].plots[2] isa LineSegments
    @test p.plots[end].plots[2][1][] == Point{2,Float32}[Float32[0.6, 3.0], Float32[1.4, 3.0]]

    p = crossbar(1, 3, 2, 4; show_notch = true, notchmin = 2.5, notchmax = 3.5);
    @test p.plots[end] isa CrossBar
    @test p.plots[end].plots[1] isa Poly
    @test p.plots[end].plots[1][1][][1] isa AbstractPlotting.AbstractMesh
    poly = Point{2,Float32}[[0.6, 2.0], [1.4, 2.0], [1.4, 2.5], [1.2, 3.0], [1.4, 3.5],
                            [1.4, 4.0], [0.6, 4.0], [0.6, 3.5], [0.8, 3.0], [0.6, 2.5]]
    @test map(Point2f0, p.plots[end].plots[1][1][][1].position) == poly
    @test p.plots[end].plots[2] isa LineSegments
    @test p.plots[end].plots[2][1][] == Point{2,Float32}[Float32[0.8, 3.0], Float32[1.2, 3.0]]
end

@testset "boxplot" begin
    a = repeat(1:5, inner = 20)
    b = 1:100
    p = boxplot(a, b)
    plts = p[end].plots
    @test length(plts) == 3
    @test plts[1] isa Scatter
    @test isempty(plts[1][1][])

    # test categorical
    a = repeat(["a", "b", "c", "d", "e"], inner = 20)
    b = 1:100
    p = boxplot(a, b; whiskerwidth = 1.0)
    plts = p[end].plots
    @test length(plts) == 3
    @test plts[1] isa Scatter
    @test isempty(plts[1][1][])

    @test plts[2] isa LineSegments
    pts = Point{2, Float32}[
        [1.0, 5.75], [1.0, 1.0], [0.6, 1.0], [1.4, 1.0], [1.0, 15.25],
        [1.0, 20.0], [1.4, 20.0], [0.6, 20.0], [2.0, 25.75], [2.0, 21.0],
        [1.6, 21.0], [2.4, 21.0], [2.0, 35.25], [2.0, 40.0], [2.4, 40.0],
        [1.6, 40.0], [3.0, 45.75], [3.0, 41.0], [2.6, 41.0], [3.4, 41.0],
        [3.0, 55.25], [3.0, 60.0], [3.4, 60.0], [2.6, 60.0], [4.0, 65.75],
        [4.0, 61.0], [3.6, 61.0], [4.4, 61.0], [4.0, 75.25], [4.0, 80.0],
        [4.4, 80.0], [3.6, 80.0], [5.0, 85.75], [5.0, 81.0], [4.6, 81.0],
        [5.4, 81.0], [5.0, 95.25], [5.0, 100.0], [5.4, 100.0], [4.6, 100.0]
    ]
    @test plts[2][1][] == pts

    @test plts[3] isa CrossBar
    @test plts[3].plots[1] isa Poly

    poly = [
        FRect2D(Float32[0.6, 5.75], Float32[0.8, 9.5]),
        FRect2D(Float32[1.6, 25.75], Float32[0.8, 9.5]),
        FRect2D(Float32[2.6, 45.75], Float32[0.8, 9.5]),
        FRect2D(Float32[3.6, 65.75], Float32[0.8, 9.5]),
        FRect2D(Float32[4.6, 85.75], Float32[0.8, 9.5]),
    ]

    @test plts[3].plots[1][1][] == poly

    #notch
    p = boxplot(a, b, show_notch=true)
    plts = p[end].plots

    @test length(plts) == 3

    pts = Point{2,Float32}[
        [1.0, 5.75], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 15.25],
        [1.0, 20.0], [1.0, 20.0], [1.0, 20.0], [2.0, 25.75], [2.0, 21.0],
        [2.0, 21.0], [2.0, 21.0], [2.0, 35.25], [2.0, 40.0], [2.0, 40.0],
        [2.0, 40.0], [3.0, 45.75], [3.0, 41.0], [3.0, 41.0], [3.0, 41.0],
        [3.0, 55.25], [3.0, 60.0], [3.0, 60.0], [3.0, 60.0], [4.0, 65.75],
        [4.0, 61.0], [4.0, 61.0], [4.0, 61.0], [4.0, 75.25], [4.0, 80.0],
        [4.0, 80.0], [4.0, 80.0], [5.0, 85.75], [5.0, 81.0], [5.0, 81.0],
        [5.0, 81.0], [5.0, 95.25], [5.0, 100.0], [5.0, 100.0], [5.0, 100.0],
    ]

    @test plts[2] isa LineSegments
    @test plts[2][1][] == pts

    @test plts[3] isa CrossBar
    @test plts[3].plots[1] isa Poly

    notch_boxes = Vector{Point{2,Float32}}[map(Point2f0, [[0.6, 5.75], [1.4, 5.75], [1.4, 7.14366], [1.2, 10.5], [1.4, 13.8563], [1.4, 15.25], [0.6, 15.25], [0.6, 13.8563], [0.8, 10.5], [0.6, 7.14366]]),
                                           map(Point2f0, [[1.6, 25.75], [2.4, 25.75], [2.4, 27.1437], [2.2, 30.5], [2.4, 33.8563], [2.4, 35.25], [1.6, 35.25], [1.6, 33.8563], [1.8, 30.5], [1.6, 27.1437]]),
                                           map(Point2f0, [[2.6, 45.75], [3.4, 45.75], [3.4, 47.1437], [3.2, 50.5], [3.4, 53.8563], [3.4, 55.25], [2.6, 55.25], [2.6, 53.8563], [2.8, 50.5], [2.6, 47.1437]]),
                                           map(Point2f0, [[3.6, 65.75], [4.4, 65.75], [4.4, 67.1437], [4.2, 70.5], [4.4, 73.8563], [4.4, 75.25], [3.6, 75.25], [3.6, 73.8563], [3.8, 70.5], [3.6, 67.1437]]),
                                           map(Point2f0, [[4.6, 85.75], [5.4, 85.75], [5.4, 87.1437], [5.2, 90.5], [5.4, 93.8563], [5.4, 95.25], [4.6, 95.25], [4.6, 93.8563], [4.8, 90.5], [4.6, 87.1437]])]
    meshes = plts[3].plots[1][1][]
    @testset for (i, mesh) in enumerate(meshes)
        @test mesh isa AbstractPlotting.AbstractMesh
        vertices = map(Point2f0, mesh.position)
        @test vertices ≈ notch_boxes[i]
    end
end
