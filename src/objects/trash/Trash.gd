class_name Trash
extends RigidBody2D

# Emitted when the trash touched something and thus the player lost control
signal touched_anything(trash)
# Emitted when the trash touched the trash bin (or something that is inside the bin)
signal touched_trash_bin(trash)
# Emitted when the trash touched the floor (or something that is lying on the floor)
signal touched_floor(trash)

# Constant
const IS_TRASH = true

# Trash properties
export var score_value := 1

# State variables
var has_touched_anything := false
var is_in_trash_bin := false
var is_on_floor := false
var player_controlled := false
var player_owner := 1
var player_velocity := Vector2(0, 0)
var player_rotation := 0.0

func _integrate_forces(_state) -> void:
    if player_controlled:
        linear_velocity = player_velocity
        angular_velocity = player_rotation

func start_control() -> void:
    player_controlled = true
    player_velocity = Vector2(0, 0)

func stop_control() -> void:
    player_controlled = false

func move_by_player(new_velocity: Vector2, new_rotation: float) -> void:
    player_velocity = new_velocity
    player_rotation = new_rotation

# Called when a collision with another body happens
func _on_Trash_body_entered(body: Node) -> void:
    var play_sound := false

    # If the player is still controlling the trash, the trash should be dropped automatically
    if not has_touched_anything:
        # Ignore collision if its with another player controlled object (chaos mode)
        if body.get("IS_TRASH") and not body.get("has_touched_anything"):
            prints(self, "Trash has touched trash that has not landed yet. Ignore.")
            play_sound = true
        else:
            prints(self, "Trash has touched something")
            has_touched_anything = true
            play_sound = true
            stop_control()
            emit_signal("touched_anything", self)

    # Detect when the trash lands in the trash bin (or collides with any trash in the bin)
    if not is_in_trash_bin and (body is TrashBin or body.get("is_in_trash_bin")):
        prints(self, "Trash landed in the trash bin")
        is_in_trash_bin = true
        play_sound = true
        emit_signal("touched_trash_bin", self)

    # Detect when the trash lands on the floor (or on any trash that is already lying on the floor)
    if not is_on_floor and (body is Floor or body.get("is_on_floor")):
        if body is Floor and (body as Floor).body_really_touches_floor(self) == false:
            prints(self, "Trash glitched through the bottom of the bin into the floor. Ignore.")
            return

        prints(self, "Trash landed on the floor")
        is_on_floor = true
        play_sound = true
        emit_signal("touched_floor", self)

    if play_sound and Settings.sfx_enabled:
        ($AudioStreamPlayer as AudioStreamPlayer).play()
