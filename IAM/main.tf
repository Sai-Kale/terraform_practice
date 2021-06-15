#Creating DevOps Group
resource "aws_iam_group" "devops_group" {
  name = "DevOps"
}

#Creating IAM users
resource "aws_iam_user" "devops_users" {
  #path          = "/"
  for_each      = toset(var.iam_users)
  name          = each.value
  force_destroy = true
}

#Adding Pritam and Saikumar to the devops group using iteration
resource "aws_iam_user_group_membership" "devops-membership" {
  for_each = toset(var.iam_users)
  user   = aws_iam_user.devops_users[each.key].name
  groups = [aws_iam_group.devops_group.name] #this is a string we can add multiple groups here
}

#Creating an IAM group policy
resource "aws_iam_policy" "devops_policy" {
  name        = "devops_policy"
  description = "An test Admin policy"
  policy      = "${file("policy.json")}" #giving admin policy
}

#Attaching the policy to DevOps group
resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.devops_group.name
  policy_arn = aws_iam_policy.devops_policy.arn
  #policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #adding the pre-exsisting administrator policy via policy arn
}
