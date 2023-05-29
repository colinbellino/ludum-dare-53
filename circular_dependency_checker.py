import os
import re
import networkx as nx


def build_class_graph(directory):
    """Builds a directed acyclic graph of class dependencies."""
    # Create a graph to store the dependencies
    graph = nx.DiGraph()
    dependencies = {}

    # Find all .gd files in the directory
    for root, dirs, files in os.walk(directory):
        for file in files:
            if not file.endswith(".gd"):
                continue

            file_path = os.path.join(root, file)
            # Find the class name in the file
            with open(file_path, "r") as f:
                contents = f.read()
                match = re.search(r"^class_name\s+(\w+)", contents, re.MULTILINE)
                if not match:
                    continue

                class_name = match.group(1)
                graph.add_node(class_name)

                # Find the dependencies of the class
                for dep_match in re.finditer(
                    r"^\s*extends\s+(\w+)", contents, re.MULTILINE
                ):
                    dep_name = dep_match.group(1)
                    graph.add_edge(class_name, dep_name)

                # Find all uses of the class name in other files
                for root2, dirs2, files2 in os.walk(directory):
                    for file2 in files2:
                        if not file2.endswith(".gd"):
                            continue

                        if file_path == os.path.join(root2, file2):
                            continue

                        with open(os.path.join(root2, file2), "r") as f2:
                            contents2 = f2.read()
                            if re.search(rf"\b{class_name}\b", contents2):
                                print(
                                    file2.ljust(30, " "),
                                    f"--> class_name {class_name}".ljust(50, " "),
                                    f" from {file}",
                                )
                                graph.add_edge(class_name, file2)
                                dependencies[file2] = file

    # Set the node positions using the Kamada-Kawai algorithm
    pos = nx.kamada_kawai_layout(graph)

    # Set the node positions in the graph
    nx.set_node_attributes(graph, pos, "pos")

    return graph, dependencies


def debug_graph(graph):
    """Builds and visualizes a graph of class dependencies in the directory."""
    import plotly.graph_objects as go

    # Create the plotly figure
    fig = go.Figure()

    # Add the nodes to the figure
    for node in graph.nodes():
        x, y = graph.nodes[node]["pos"]
        fig.add_trace(
            go.Scatter(
                x=[x],
                y=[y],
                text=[node],
                hovertext=[f"Class: {node}"],
                mode="markers",
                marker=dict(
                    symbol="circle", size=20, line=dict(width=1, color="black"),
                ),
                name=node,
            )
        )

    # Add the edges to the figure
    for edge in graph.edges():
        x0, y0 = graph.nodes[edge[0]]["pos"]
        x1, y1 = graph.nodes[edge[1]]["pos"]
        fig.add_trace(
            go.Scatter(
                x=[x0, x1],
                y=[y0, y1],
                text=[f"{edge[0]} -> {edge[1]}", ""],
                hovertext=[f"Depends on: {edge[1]}", ""],
                mode="lines+markers+text",
                line=dict(width=2, color="black"),
                marker=dict(size=0),
                textposition="middle right",
                showlegend=False,
            )
        )

    # Customize the layout and style of the figure
    fig.update_layout(
        title="Class Dependency Graph",
        title_font_size=24,
        margin=dict(l=20, r=20, t=50, b=20),
        hovermode="closest",
        plot_bgcolor="white",
        showlegend=False,
    )

    # Show the figure
    fig.show()


def find_circular_dependencies(directory, debug: bool = False):
    """Finds circular dependencies between classes in the directory."""
    graph, dependencies = build_class_graph(directory)

    # Draw the graph
    if debug:
        debug_graph(graph)

    circular_dependencies = []

    for file, dependency in dependencies.items():
        visited = set()
        path = [file]

        while dependency and dependency not in visited:
            visited.add(dependency)
            path.append(dependency)
            dependency = dependencies.get(dependency)

            # Circular check
            if dependency in path:
                start_index = path.index(dependency)
                circular_dependency = path[start_index:]
                if circular_dependency not in circular_dependencies:
                    circular_dependencies.append(circular_dependency)
                break

    # Convert circular_dependencies to dependency paths
    dependency_paths = []
    for circular_dependency in circular_dependencies:
        dependency_path = " -> ".join(circular_dependency)
        dependency_paths.append(dependency_path)

    return dependency_paths


# Example usage
circular_deps = find_circular_dependencies("./")
print("----------------------------------")
if circular_deps:
    print(" Circular dependencies found!")
    for dep in circular_deps:
        print("\t", dep)
else:
    print(" No circular dependencies found.")
print("----------------------------------")
