use aoc_2020::*;
use std::str::FromStr;
use std::collections::HashMap;
use std::fs;

fn main() -> Result<(), GenError> {
  let mut inputs = vec![];
  for s in fs::read_to_string("data/day15input.txt")?.split(",") {
    inputs.push(usize::from_str(s.trim())?);
  }
  let mut curr = 0;
  let mut next = 0;
  let mut last = HashMap::new();
  for t in 0 .. 30000000 {
    curr = if t < inputs.len() { inputs[t] } else { next };
    next = match last.get(&curr) {
      None => 0,
      Some(t0) => t - t0
    };
    last.insert(curr, t);
  }
  println!("Final: {}", curr);
  Ok(())
}
