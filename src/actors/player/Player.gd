class_name Player
extends Node2D

# Emitted when the player dropped a trash object (i.e. let go of it)
signal trash_dropped
# Emitted when the spawn retry timer expired
signal retry_spawn
# Emitted when the score has changed
signal score_changed(new_score)

# Constants
const TRASH_SPEED_PLAYER = 200
const TRASH_SPEED_DOWN = 100
const TRASH_SPEED_DROP = 400
const TRASH_ROT_SPEED = 5

# Node references
onready var spawn_area := $SpawnArea as Area2D
onready var spawn_retry_timer := $SpawnRetryTimer as Timer

# Player number (starting with 1, set by the main game)
var player_number := 1

# Input action names, depending on the player number
onready var input_action_left = "player%d_left" % [player_number]
onready var input_action_right = "player%d_right" % [player_number]
onready var input_action_up = "player%d_up" % [player_number]
onready var input_action_down = "player%d_down" % [player_number]
onready var input_action_left_stick  = "player%d_left_stick" % [player_number]
onready var input_action_right_stick = "player%d_right_stick" % [player_number]
onready var input_action_up_stick = "player%d_up_stick" % [player_number]
onready var input_action_down_stick = "player%d_down_stick" % [player_number]
onready var input_action_turn_cw = "player%d_turn_cw" % [player_number]
onready var input_action_turn_ccw = "player%d_turn_ccw" % [player_number]
onready var input_action_drop = "player%d_drop" % [player_number]

# State variables
var game_over := false
var current_trash: Trash = null

# Score
var current_score := 0


func _process(delta) -> void:
    if current_trash:
        if Input.is_action_just_pressed(input_action_drop):
            drop_trash(true)
        else:
            process_movement_input()


func process_movement_input() -> void:
    # Process player movement
    var trash_direction := Vector2(0, 0)
    var trash_rotation := 0

    if Input.is_action_pressed(input_action_left) or Input.is_action_pressed(input_action_left_stick):
        trash_direction.x -= 1
    if Input.is_action_pressed(input_action_right) or Input.is_action_pressed(input_action_right_stick):
        trash_direction.x += 1

    # Accelerate downwards motion
    if Input.is_action_pressed(input_action_down) or Input.is_action_pressed(input_action_down_stick):
        trash_direction.y += 1

    # Rotation
    if Input.is_action_pressed(input_action_turn_cw):
        trash_rotation += 1
    if Input.is_action_pressed(input_action_turn_ccw):
        trash_rotation -= 1

    var trash_velocity := trash_direction * TRASH_SPEED_PLAYER + Vector2(0, 1) * TRASH_SPEED_DOWN

    # Set movement vector (exact movement is processed by the trash object)
    current_trash.move_by_player(trash_velocity, trash_rotation * TRASH_ROT_SPEED)


# Start controlling a piece of trash
func take_trash(trash: Trash) -> void:
    # If the player is still controlling an object, drop it
    if current_trash:
        drop_trash()

    prints(self, "Take trash")

    # Take control of the trash
    current_trash = trash
    current_trash.start_control()


# Drop the trash the player is controlling (voluntary drop)
func drop_trash(accelerate_fall := false) -> void:
    if not current_trash:
        return

    prints(self, "Drop trash")

    # Remove object from player control and speed up the fall a bit
    current_trash.stop_control()
    current_trash.apply_impulse(Vector2(), Vector2(0, TRASH_SPEED_DROP))
    current_trash = null

    # Emit a signal to the main game
    emit_signal("trash_dropped")


# Return true if the player controls a trash object right now
func is_controlling_trash() -> bool:
    return current_trash != null


# Returns true unless there are objects inside the spawn area (making it unsafe to spawn new objects)
func is_spawn_area_clear() -> bool:
    var overlapping_bodies := spawn_area.get_overlapping_bodies()
    return len(overlapping_bodies) == 0


# Add points to the player's score
func add_score(points: int) -> void:
    current_score += points
    prints(self, "New score:", current_score)
    emit_signal("score_changed", current_score)


# Start the spawn retry timer (1 second)
func start_spawn_retry_timer() -> void:
    spawn_retry_timer.start(1)


# Called when the retry timer expires
func _on_SpawnRetryTimer_timeout() -> void:
    # Ignore timer when already controlling an object
    if not current_trash:
        emit_signal("retry_spawn")
