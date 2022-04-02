class_name Trash
extends RigidBody2D

# Emitted when the trash object touched something and thus the player lost control
signal touched_world

# State variables
var has_landed: bool = false
var player_controlled: bool = false
var player_velocity: Vector2 = Vector2(0, 0)
var player_rotation: float = 0

func _integrate_forces(state):
    if player_controlled:
        linear_velocity = player_velocity
        angular_velocity = player_rotation

func start_control():
    player_controlled = true
    player_velocity = Vector2(0, 0)

func stop_control():
    player_controlled = false

func move_by_player(new_velocity: Vector2, new_rotation: float):
    player_velocity = new_velocity
    player_rotation = new_rotation

func _on_Trash_body_entered(body):
    # Some collision occured. Drop the trash.
    if not has_landed:
        stop_control()
        emit_signal("touched_world")
        has_landed = true
