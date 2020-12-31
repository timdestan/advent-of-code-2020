use std::fs;

fn find_loop_size(value: i64) -> i64 {
  let mut n = 0;
  let mut x = 1;
  loop {
    x = (x * 7) % 20201227;
    n += 1;
    if x == value {
      return n;
    }
  }
}

fn run_loop(s: i64, n: i64) -> i64 {
  let mut x = 1;
  let mut i = 0;
  while i < n {
    x = (x * s) % 20201227;
    i += 1;
  }
  x
}

fn main() {
  let mut ns = vec![];
  for l in fs::read_to_string("data/day25input.txt").unwrap().lines() {
    ns.push(l.trim().parse().unwrap());
  }
  let size = find_loop_size(ns[0]);
  println!("{}", run_loop(ns[1], size));
}



