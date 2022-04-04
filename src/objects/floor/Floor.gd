class_name Floor
extends StaticBody2D

# Reference to trash bin (set externally from MainGame)
var trash_bin: TrashBin = null


# Check whether a body really touched the floor (and isn't glitching through the bin into the floor)
func body_really_touches_floor(body: Node) -> bool:
    if trash_bin:
        var trash_bin_bottom_area := trash_bin.get_node("BottomSafeArea") as Area2D
        return not trash_bin_bottom_area.overlaps_body(body)
    else:
        return true
