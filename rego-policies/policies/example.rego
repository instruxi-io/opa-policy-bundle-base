package example

default allow = false

allow {
    input.user.role == "admin"
}
