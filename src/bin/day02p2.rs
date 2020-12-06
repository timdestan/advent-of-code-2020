use aoc_2020::*;
use regex::Regex;
use std::str::FromStr;
use std::fs;

fn main() -> Result<(), GenError> {
  let mut valid_passwords = 0;
  let mut total_passwords = 0;
  let re = Regex::new(r"^(\d+)-(\d+)\s(\w):\s(\w+)$")?;

  for line in fs::read_to_string("data/day02input.txt")?.lines() {
    for cap in re.captures_iter(line.trim()) {
      // eprintln!("{}, {:?}", line, &cap);
      // cap[0] is the whole thing.
      let pos1 = usize::from_str(&cap[1])? - 1;
      let pos2 = usize::from_str(&cap[2])? - 1;
      let required_char = char::from_str(&cap[3])?;
      let pw = &cap[4];

      total_passwords += 1;
      let matches = pw.chars().enumerate().filter(|&(i, c)| (i == pos2 || i == pos1) && c == required_char).count();
      if matches == 1 {
        valid_passwords += 1;
      }
    }
  }
  println!("{} of {} are valid.", valid_passwords, total_passwords);
  Ok(())
}
