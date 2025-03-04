extends Node

func _ready() -> void:
	EventBus.connect("live_zone_entered", enter_live_zone)
	EventBus.connect("live_zone_exited", exit_live_zone)
	EventBus.connect("death_zone_entered", enter_death_zone)

var zone_queue : Array[LiveZone]
var zone : LiveZone = null

func enter_live_zone(z : LiveZone, b : Node2D):
	if not b == owner:
		pass
	if zone:
		zone_queue.push_front(zone)
	zone = z
	if z.SpawnPoint:
		owner.respawn_location = z.SpawnPoint.global_position

func exit_live_zone(z : LiveZone, b : Node2D):
	if not b == owner:
		pass
	if z == zone:
		if len(zone_queue):
			zone = zone_queue.pop_front()
		else:	#don't queue this zone because we aren't even in it anymore
			owner.die.call_deferred()
			
	else:
		zone_queue.erase(z)

func enter_death_zone(z : DeathZone, b : Node2D):
	if not b == owner:
		pass
	owner.die.call_deferred()
