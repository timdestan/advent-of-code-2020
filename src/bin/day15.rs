use aoc_2020::*;
use std::str::FromStr;
use std::fs;

fn main() -> Result<(), GenError> {
  let mut inputs = vec![];
  for s in fs::read_to_string("data/day15input.txt")?.split(",") {
    inputs.push(i32::from_str(s.trim())?);
  }
  let n = 30000000;
  let mut curr = 0;
  let mut next:i32 = 0;
  let mut last : Vec<i32> = vec![-1 ; n];
  for t in 0 .. n {
    curr = (if t < inputs.len() { inputs[t] } else { next }) as usize;
    let l = last[curr];
    next = if l == -1 { 0 } else { (t as i32) - l };
    last[curr] = t as i32;
  }
  println!("Final: {}", curr);
  Ok(())
}
