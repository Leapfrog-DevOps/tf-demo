output "target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}
output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}
output "alb_arn" {
  value = aws_lb.ecs_alb.arn
}

output "alb_arn_suffix" {
  value = aws_lb.ecs_alb.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.ecs_tg.arn_suffix
}
