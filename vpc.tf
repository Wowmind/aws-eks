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

    availability_zone = element(data.aws_availability_-zones.ailable.names, count.index)

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
    
}