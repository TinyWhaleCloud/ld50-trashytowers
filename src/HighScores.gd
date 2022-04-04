extends Node


var scores = [{"name": "Nobody", "score": 0}]

class ScoreSorter:
    static func sort_descending(a, b) -> bool:
        return a["score"] > b["score"]


func sort_scores() -> void:
    scores.sort_custom(ScoreSorter, "sort_descending")

func add_score(score) -> void:
    scores.push_back(score)
    sort_scores()
    print(scores)
