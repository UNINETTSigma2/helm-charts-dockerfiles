#!/usr/bin/python3
import sys

def res_to_megs(res):
    if res.endswith("G"):
        return int(float(res[:-1]) * 1000)
    elif res.endswith("M"):
        return int(res[:-1])

    return None

def res_to_str(res):
    if res % 1000 == 0:
        return "%dg" % (res / 1000)
    else:
        return "%dm" % res

mem = sys.argv[1]
mem_ratio = float(sys.argv[2])
mem_max = res_to_megs(sys.argv[3])

mem_megs = res_to_megs(mem)
if mem_megs is None:
    sys.exit(1)

daemon_mem = min(mem_megs * mem_ratio, mem_max)
worker_mem = mem_megs - daemon_mem

print("%s %s" % (res_to_str(daemon_mem), res_to_str(worker_mem)))

