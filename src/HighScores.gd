extends Node

const HIGHSCORE_FILENAME = "user://highscores.json"

var scores = [{"name": "Nobody", "score": 0}]

class ScoreSorter:
    static func sort_descending(a, b) -> bool:
        return a["score"] > b["score"]


func _ready() -> void:
    load_highscores()

func sort_scores() -> void:
    scores.sort_custom(ScoreSorter, "sort_descending")

func add_score(score) -> void:
    scores.push_back(score)
    sort_scores()
    print(scores)
    save_highscores()


func load_highscores() -> void:
    prints(self, "Loading highscores from filesystem...")

    # Try to load the highscore file
    var highscore_file := File.new()
    if not highscore_file.file_exists(HIGHSCORE_FILENAME):
        prints(self, "Highscore file does not exist yet.")
        return

    var err = highscore_file.open(HIGHSCORE_FILENAME, File.READ)
    if err != OK:
        printerr("Error opening highscore file to read: ", err)
        return

    # Parse highscore file as JSON
    var highscore_json = highscore_file.get_as_text()
    scores = parse_json(highscore_json)

func save_highscores() -> void:
    prints(self, "Saving highscores to filesystem...")

    # Try to save the highscore file
    var highscore_file := File.new()

    var err = highscore_file.open(HIGHSCORE_FILENAME, File.WRITE)
    if err != OK:
        printerr("Error opening highscore file to write: ", err)
        return

    # Dump highscore to JSON
    var highscore_json = to_json(scores)
    highscore_file.store_line(highscore_json)
