
resource "aws_autoscaling_group" "asg" {

  name = "test"

  vpc_zone_identifier = [aws_subnet.this["pub_a"].id, aws_subnet.this["pub_b"].id]

  max_size = 4

  min_size = 2

  health_check_grace_period = 240

  health_check_type = "ELB"

  force_delete = true

  target_group_arns = [aws_alb_target_group.this.arn]




  launch_template {
    id = aws_launch_template.this.id

    version = aws_launch_template.this.latest_version
  }

}

resource "aws_autoscaling_policy" "sclup" {

  name = "scale-up"

  autoscaling_group_name = aws_autoscaling_group.asg.name

  adjustment_type = "ChangeInCapacity"

  scaling_adjustment = "1"

  cooldown = "180"

  policy_type = "SimpleScaling"

}

resource "aws_autoscaling_policy" "scldw" {

  name = "scale-down"

  autoscaling_group_name = aws_autoscaling_group.asg.name

  adjustment_type = "ChangeInCapacity"

  scaling_adjustment = "-1"

  cooldown = "180"

  policy_type = "SimpleScaling"

}

