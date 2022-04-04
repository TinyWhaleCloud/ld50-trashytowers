class_name FloatingTextSpawner
extends Node2D

const FloatingTextScene = preload("res://ui/floating_text/FloatingText.tscn")

# Spawns a new floating text at the specified position
func spawn_text(text: String, position: Vector2, color = null) -> void:
    var floating_text := FloatingTextScene.instance() as FloatingText
    add_child(floating_text)

    floating_text.position = position
    floating_text.show_text(text, color)
