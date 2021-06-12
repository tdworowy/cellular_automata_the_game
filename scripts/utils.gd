#might be slow
static func product(iterable:Array, repeat:int = 1) -> Array:
	var pools:Array = []
	var result:Array = [[]]
	for i in range(repeat):
		pools.append(iterable)
	
	for pool in pools:
		for x in result:
			for y in pool:
				if ![x + [y]] in result && len(x + [y]) <= repeat:
					result.append(x + [y])
	
	var final_result:Array = []
	for res in result:
		if len(res) == repeat:
			final_result.append(res)
	return final_result


