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
      let min = usize::from_str(&cap[1])?;
      let max = usize::from_str(&cap[2])?;
      let required_char = char::from_str(&cap[3])?;
      let pw = &cap[4];

      let matching_chars = pw.chars().filter(|c| *c == required_char).count();
      total_passwords += 1;
      if matching_chars >= min && matching_chars <= max {
        valid_passwords += 1;
      }
    }
  }
  println!("{} of {} are valid.", valid_passwords, total_passwords);
  Ok(())
}
