use aoc_2020::*;
use std::convert::TryFrom;
use std::fs;

fn read_cups() -> Result<Vec<usize>, GenError> {
  let mut cups = vec![];
  for c in fs::read_to_string("data/day23input.txt")?.trim().chars() {
    cups.push(usize::try_from(c.to_digit(10).unwrap()).unwrap());
  }
  let max_cup = cups.iter().max().unwrap();
  for i in max_cup + 1..=1_000_000 {
    cups.push(i);
  }
  Ok(cups)
}

fn build_next(cups: &Vec<usize>) -> Vec<usize> {
  let mut next = vec![0; cups.len() + 1];
  for (c1, c2) in cups.iter().zip(cups.iter().skip(1)) {
    next[*c1] = *c2
  }
  next[cups[cups.len() - 1]] = cups[0];
  next
}

fn find_to_move(next: &Vec<usize>, curr: usize) -> (usize, usize, usize) {
  let x = next[curr];
  let y = next[x];
  let z = next[y];
  (x, y, z)
}

fn main() -> Result<(), GenError> {
  let mut cups: Vec<usize> = read_cups()?;
  let mut next: Vec<usize> = build_next(&cups);
  let mut curr = cups[0];
  cups.sort();
  let ncups = cups.len() as i32;

  let nmoves = 10_000_000;

  for _ in 1..=nmoves {
    let (x, y, z) = find_to_move(&next, curr);

    let find_dest = |curr: usize| -> usize {
      let mut i = (curr as i32) - 2;
      loop {
        let curr = cups[((i + ncups) % ncups) as usize];
        if curr != x && curr != y && curr != z {
          return curr;
        }
        i -= 1;
      }
    };
    let dest = find_dest(curr);

    let tmp = next[dest];
    next[curr] = next[z];
    next[dest] = x;
    next[x] = y;
    next[y] = z;
    next[z] = tmp;

    curr = next[curr];
  }

  let x = next[1];
  let y = next[x];
  println!("order = {} * {} = {}", x, y, x * y);
  Ok(())
}
