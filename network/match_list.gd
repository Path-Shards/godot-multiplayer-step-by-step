class_name MatchList
extends RefCounted

const LIFETIME_SECONDS := 3.0


func register(matches: Array, address: String, now: float) -> Array:
	for found in matches:
		if found["address"] == address:
			found["seen_at"] = now
			return matches
	var updated := matches.duplicate()
	updated.append({"address": address, "seen_at": now})
	return updated


func drop_expired(matches: Array, now: float) -> Array:
	return matches.filter(func(found): return now - found["seen_at"] <= LIFETIME_SECONDS)
