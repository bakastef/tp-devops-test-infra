/**
No access to AWS Route53... So I can't create a zone and DNS records/aliases towards teh loadbalancer


resource "aws_route53_zone" "r53-zone-public" {


    name       = "tp-test.com"
    comment    = "New zone and domain for teh devops test "

    tags = {
        Name = "${var.env-prefix}r53-zone-public"
        Terraform   = "true"
        Owner       = var.resource-owner
        Environment = var.aws-environment
    }
}



resource "aws_route53_record" "r53-record-alb-public-fargate" {
    
    zone_id = aws_route53_zone.r53-zone-public.zone_id
    name    = "fargate.tp-test.com"
    type    = "A"
    
    alias {
        name                   = aws_alb.alb-public.dns_name
        zone_id                = aws_alb.alb-public.zone_id
        evaluate_target_health = false
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "r53-record-alb-public-hello" {

    zone_id = aws_route53_zone.r53-zone-public.zone_id
    name    = "hello.tp-test.com"
    type    = "A"

    alias {
        name                   = aws_alb.alb-public.dns_name
        zone_id                = aws_alb.alb-public.zone_id
        evaluate_target_health = false
    }

    lifecycle {
        create_before_destroy = true
    }
}

*/