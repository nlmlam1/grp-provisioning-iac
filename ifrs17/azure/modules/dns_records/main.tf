provider "dns" {
  update {
    server        = "${var.server}"
    key_name      = "${var.key_name}"
    key_algorithm = "${var.key_algorithm}"
    key_secret    = "${var.key_secret}"
  }
}

resource "dns_a_record_set" "a" {
  count     = "${length(var.names) > 0 ? 1 : 0 }"
  zone      = "${var.zone}"
  name      = "${element(var.names, 0)}"
  addresses = ["${var.addresses}"]
  ttl       = "${var.ttl}"
}

resource "dns_cname_record" "cname" {
  count = "${length(var.names) > 1 ? length(var.names) - 1 : 0 }"
  zone  = "${var.zone}"
  name  = "${element(var.names, count.index + 1)}"
  cname = "${join(".", list(element(var.names, 0), var.zone))}"
  ttl   = 300
}
