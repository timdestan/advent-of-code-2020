use std::error::Error;
use std::fs;
use std::str::FromStr;

pub type GenError = Box<dyn Error>;

pub fn parse_ints_from_file(fname: &str) -> Result<Vec<i32>, GenError> {
  let mut ints = vec![];
  for line in fs::read_to_string(fname)?.lines() {
    ints.push(i32::from_str(line.trim())?);
  }
  Ok(ints)
}
