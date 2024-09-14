#include <emscripten/bind.h>
#include <fstream>
#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Surface_mesh.h>
#include <CGAL/Polygon_mesh_processing/corefinement.h>

#include "bindings.h"

typedef CGAL::Exact_predicates_inexact_constructions_kernel Kernel;
typedef CGAL::Surface_mesh<Kernel::Point_3> Mesh;
namespace PMP = CGAL::Polygon_mesh_processing;

Mesh boolean_operation(const Mesh &mesh1, const Mesh &mesh2)
{
    Mesh result;
    std::map<boost::graph_traits<Mesh>::edge_descriptor, bool> edgeConstraintMap;
    bool valid_union = PMP::corefine_and_compute_union(mesh1, mesh2, result);

    if (valid_union)
    {
        std::cout << "Union was successfully computed";
    }
    return result;
}

Binding code for Emscripten
EMSCRIPTEN_BINDINGS(my_module)
{
    emscripten::class_<Mesh>("Mesh")
        .constructor<>()
        .function("boolean_operation", &boolean_operation);
}
