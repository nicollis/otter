UserType = GraphQL::ObjectType.define do
  name "User"
    description "A User"
    field :if, types.ID
    field :name, types.String
    field :email, types.String
    field :followers do
      type types[UserType]
      argument :size, types.Int
      resolve -> (user, args, ctx) {
        user.followers.limit(args[:size])
      }
    end
    field :following do
      type types[UserType]
      argument :size, types.Int
      resolve -> (user, args, ctx) {
        user.followers.limit(args[:size])
      }
    end
end 