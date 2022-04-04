class_name FloatingText
extends Node2D

# Constants
const TWEEN_DURATION = 1.0
const TWEEN_MOVEMENT = Vector2(0, -150)

# Node references
onready var label := $Label as Label
onready var tween := $Tween as Tween

func show_text(new_text: String, color = null) -> void:
    # Set default values
    color = (color as Color) if color != null else Color(1, 0, 1)

    # Display the text
    label.text = new_text
    label.modulate = color

    # Start the animation
    tween.interpolate_property(
        label, "rect_position",
        label.rect_position, label.rect_position + TWEEN_MOVEMENT,
        TWEEN_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
    )
    tween.interpolate_property(
        label, "modulate:a",
        1.0, 0.0,
        TWEEN_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
    )
    tween.start()

    # Remove text after the animation has finished
    yield(tween, "tween_all_completed")
    queue_free()
