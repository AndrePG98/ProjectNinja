class_name Factions extends RefCounted

enum Faction {
	PLAYER,
	ENEMY,
	NEUTRAL,
}

const FACTION_INTERACTIONS: Dictionary = {
	Faction.PLAYER: [Faction.ENEMY],
	Faction.ENEMY: [Faction.PLAYER],
	Faction.NEUTRAL: [],
}


static func can_interact(attacker: Faction, target: Faction) -> bool:
	return target in FACTION_INTERACTIONS.get(attacker, [])
