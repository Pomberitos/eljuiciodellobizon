class_name Slasher
extends CharacterBody2D

@export_range(20, 45, 1, "degrees") var angle_degrees
@export_range(10, 50, 1) var max_view_distance
@export_range(5, 10, 1, "degrees") var angle_between_rays



func generate_raycast()->void:
    var ray_count:float = deg_to_rad(angle_degrees) / deg_to_rad(angle_between_rays)
    
    for ray_index in ray_count:
        var ray: RayCast2D = RayCast2D.new()
        var angle: float =  deg_to_rad(angle_degrees) * (ray_index - ray_count/2.0)
        ray.target_position = Vector2.UP.rotated(angle) * max_view_distance
        add_child(ray)
        ray.enabled
