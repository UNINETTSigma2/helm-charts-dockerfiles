#!/usr/bin/python
import sys

def res_to_megs(res):
    if res.endswith("G"):
        return int(float(res[:-1]) * 1000)
    elif res.endswith("M"):
        return int(res[:-1])

    return None

mem = sys.argv[1]
mem_ratio = float(sys.argv[2])
mem_max = res_to_megs(sys.argv[3])

mem_megs = res_to_megs(mem)
if mem_megs is None:
    sys.exit(1)

daemon_mem = min(mem_megs * mem_ratio, mem_max)
worker_mem = mem_megs - daemon_mem

print("%dm %dm" % (daemon_mem, worker_mem))

