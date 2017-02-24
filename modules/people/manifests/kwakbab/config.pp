class people::kwakbab::config {
  $home     = "/Users/${::boxen_user}"

  include people::kwakbab::config::git
}