use aoc_2020::*;

fn main() -> Result<(), GenError> {
  let nums = parse_ints_from_file("data/day01input.txt")?;

  for i in 0..nums.len() {
    for j in i + 1..nums.len() {
      for k in j + 1..nums.len() {
        if nums[i] + nums[j] + nums[k] == 2020 {
          println!("{}", nums[i] * nums[j] * nums[k]);
          return Ok(());
        }
      }
    }
  }

  eprintln!("Couldn't find the triple.");
  std::process::exit(1);
}
