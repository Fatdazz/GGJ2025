extends Node3D

var mesh
var meshtool

var paint = preload("res://GodotPaintDemo-master/paint.png")
var brush = preload("res://GodotPaintDemo-master/brush.png")
var tex = preload("res://GodotPaintDemo-master/tex.png")

var img_tex
var img_paint
var img_brush

func _ready():
	#mesh = get_node("mesh").get_mesh().get_mesh_array()
	#meshtool = MeshDataTool.new()
	#meshtool.create_from_surface(mesh, 0)
	img_tex = tex.get_image()
	img_brush = brush.get_image()
	img_paint = paint.get_image()
	$mesh.get_mesh().surface_get_material(0).set_texture(0, img_tex)
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, $mesh.get_mesh().get_mesh_arrays())
	meshtool = MeshDataTool.new()
	meshtool.create_from_surface(mesh, 0)

	#print("NB faces : ", meshtool.get_face_count())

func equals_with_epsilon(v1, v2, epsilon):
	if (v1.distance_to(v2) < epsilon):
		return true
	return false

func get_face(point, normal, epsilon = 0.6):
	#print("he + ", meshtool.get_face_count())
	
	for idx in range(meshtool.get_face_count()):
		
		if !equals_with_epsilon(meshtool.get_face_normal(idx), normal, epsilon):
			continue
		# Normal is the same-ish, so we need to check if the point is on this face
		var v1 = meshtool.get_vertex(meshtool.get_face_vertex(idx, 0))
		var v2 = meshtool.get_vertex(meshtool.get_face_vertex(idx, 1))
		var v3 = meshtool.get_vertex(meshtool.get_face_vertex(idx, 2))
		if is_point_in_triangle(point, v1, v2, v3):
			return idx
	return null

func barycentric(P, A, B, C):
	var b = Geometry3D.get_triangle_barycentric_coords(P, A,B,C)
	return b
	# Returns barycentric co-ordinates of point P in triangle ABC
	#var mat1 = Matrix3(A, B, C)
	#var det = mat1.determinant()
	#var mat2 = Matrix3(P, B, C)
	#var factor_alpha = mat2.determinant()
	#var mat3 = Matrix3(P, C, A)
	#var factor_beta = mat3.determinant()
	#var alpha = factor_alpha / det;
	#var beta = factor_beta / det;
	#var gamma = 1.0 - alpha - beta;
	#return Vector3(alpha, beta, gamma)

func is_point_in_triangle(point, v1, v2, v3):
	var bc = barycentric(point, v1, v2, v3)
	if bc.x < 0 or bc.x > 1:
		return false
	if bc.y < 0 or bc.y > 1:
		return false
	if bc.z < 0 or bc.z > 1:
		return false
	return true

func get_uv_coords(point, normal):
	# Gets the uv coordinates on the mesh given a point on the mesh and normal
	# these values can be obtained from a raycast
	var face = get_face(point, normal)
	if face == null:
		return null
	var v1 = meshtool.get_vertex(meshtool.get_face_vertex(face, 0))
	var v2 = meshtool.get_vertex(meshtool.get_face_vertex(face, 1))
	var v3 = meshtool.get_vertex(meshtool.get_face_vertex(face, 2))
	var bc = barycentric(point, v1, v2, v3)
	var uv1 = meshtool.get_vertex_uv(meshtool.get_face_vertex(face, 0))
	var uv2 = meshtool.get_vertex_uv(meshtool.get_face_vertex(face, 1))
	var uv3 = meshtool.get_vertex_uv(meshtool.get_face_vertex(face, 2))
	return (uv1 * bc.x) + (uv2 * bc.y) + (uv3 * bc.z)
	
func paint_uv(point, normal, color):
	# Brush transfers onto the mesh's texture at the point and normal obtained from a raycast
	var uv = get_uv_coords(point, normal)
	if uv == null:
		#print("UV null")
		return
	var rgb = $mesh.get_mesh().surface_get_material(0).get_texture(0)
	#var rgb = rgb_c.get_image()
	print("RGB paint: ", rgb)
	uv *= Vector2(rgb.get_size())
	#var data = rgb.get_data()
	rgb.set_pixel(uv.x, uv.y, color)
	#data.brush_transfer(img_paint.get_data(), img_brush.get_data(), Vector2(uv.x - img_brush.get_width()/2, uv.y - img_brush.get_height()/2))
	#rgb.set_data(data)
	$mesh.get_mesh().surface_get_material(0).set_texture(0, rgb)
	print("youhou")
