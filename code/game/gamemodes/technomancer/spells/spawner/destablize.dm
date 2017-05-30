/datum/technomancer/spell/destablize
	name = "Destablize"
	desc = "Creates an unstable disturbance at the targeted tile, which will afflict anyone nearby with instability who remains nearby.  This can affect you \
	and your allies as well.  The disturbance lasts for twenty seconds."
	cost = 100
	obj_path = /obj/item/weapon/spell/spawner/destablize
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/spawner/destablize
	name = "destablize"
	desc = "Now your enemies can feel what you go through when you have too much fun."
	icon_state = "destablize"
	cast_methods = CAST_RANGED
	aspect = ASPECT_UNSTABLE
	spawner_type = /obj/effect/temporary_effect/destablize

/obj/item/weapon/spell/spawner/destablize/New()
	..()
	set_light(3, 2, l_color = "#C26DDE")

/obj/item/weapon/spell/spawner/destablize/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(2000))
		adjust_instability(15)
		..()

/obj/effect/temporary_effect/destablize
	name = "destablizing disturbance"
	desc = "This can't be good..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "blueshatter"
	time_to_die = null
	invisibility = 0
	new_light_range = 6
	new_light_power = 20
	new_light_color = "#C26DDE"
	var/pulses_remaining = 40 // Lasts 20 seconds.
	var/instability_power = 5
	var/instability_range = 6

/obj/effect/temporary_effect/destablize/New()
	..()
	radiate_loop()

/obj/effect/temporary_effect/destablize/proc/radiate_loop()
	while(pulses_remaining)
		sleep(5)
		for(var/mob/living/L in range(src, instability_range) )
			var/radius = max(get_dist(L, src), 1)
			// Being farther away lessens the amount of instabity received.
			var/outgoing_instability = instability_power * ( 1 / (radius**2) )
			L.receive_radiated_instability(outgoing_instability)
		pulses_remaining--
	qdel(src)