resource "aws_vpc" "eks_vpc" {
    cidr_block = "10.0.0.0/16"

    tags ={
        name ="eks-vpc"
    }
}

resource "aws_subnet" "eks_subnet" {
    count = 2
    vpc_id = aws_vpc.eks_vpc.id 
    cidr_block =cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)

    availability_zone = element(data.aws_availability_zones.available.names[count.index])

    tags = {
        Name = "eks-subnet-${count.index}"
    }
}

resource "aws_internet_gateway" "eks_igw"{
    vpc_id = aws_vpc.eks_vpc.id
    
    tags = {
        Name = "eks-igw"
    }
}

resource "aws_route_table" "eks_route_table" {
 vpc_id = aws_vpc.eks_vpc.id

 route {
    cidr_block = "0.0.0.0/0"
    gatway_id = aws_internrt_gateway.eks_igw.id

}   

tags = {
    Name = "eks-route-table"
}
}

resource "aws_route_table_association" "eks_route_table_association" {
    count = length(aws_subnet.eks_subnet)
    subnet_id = element(aws_subnet.eks_subnet.*.id, count.index)
    route_table_id = aws_route_table.eks_route_table.id
}

resource "aws_security_group" "eks_cluster_sg" {
    vpc_id = aws_vpc.eks_vpc.id

    ingress {
        from_port  = 443
        to_port    = 443
        protocol   = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }

    tags = {
        Name = "eks-cluster-sg"
    }
}
