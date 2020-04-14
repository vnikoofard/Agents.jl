# Use Python 3

import timeit

sizes = (100, 1000, 10000, 100000)

print("Boid benchmark")
for N in sizes[0:3]:
  setup = f"""
gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))
from model import BoidFlockers
import random
model = BoidFlockers({N}, 100, 100, speed=1, vision=5, separation=4, cohere=0.25, separate=0.25, match=0.01)

def runthemodel(model):
  for i in range(10):
    model.step()
  """
  tt = timeit.Timer('runthemodel(model)', setup=setup)
  a = min(tt.repeat(20, 1))
  print(a)


## Micro benchmarks
print("Move agent benchmark")
for N in sizes:
  setup = f"""
gc.enable()
import os, sys
import numpy as np
sys.path.insert(0, os.path.abspath("."))
from model import BoidFlockers
import random
model = BoidFlockers({N}, 100, 100, speed=1, vision=5, separation=4, cohere=0.25, separate=0.25, match=0.01)
agent = model.schedule.agents[70]
newpos = np.random.random(2)

def move_single_agent(agent, newpos, model):
  model.space.move_agent(agent, newpos)
  """
  tt = timeit.Timer('move_single_agent(agent, newpos, model)', setup=setup)
  a = min(tt.repeat(20, 1))
  print(a)


print("Find neighbors benchmark")
for N in sizes:
  setup = f"""gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))
from model import BoidFlockers
import random
model = BoidFlockers({N}, 100, 100, speed=1, vision=5, separation=4, cohere=0.25, separate=0.25, match=0.01)
agent = model.schedule.agents[70]

def find_neighbors(agent, model):
  neighbors = model.space.get_neighbors(
            agent.pos, agent.vision, False)
  return neighbors
  """
  tt = timeit.Timer('find_neighbors(agent, model)', setup=setup)
  a = min(tt.repeat(20, 1))
  print(a)


print("Remove agent benchmark")
for N in sizes:
  setup = f"""gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))
from model import BoidFlockers
import random
model = BoidFlockers({N}, 100, 100, speed=1, vision=5, separation=4, cohere=0.25, separate=0.25, match=0.01)
agent = model.schedule.agents[70]

def find_neighbors(agent, model):
  model.space.remove_agent(agent)
  """
  tt = timeit.Timer('find_neighbors(agent, model)', setup=setup)
  a = min(tt.repeat(20, 1))
  print(a)
