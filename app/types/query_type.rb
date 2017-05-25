QueryType = GraphQL::ObjectType.define do 
  name "Query"
  description "The query root for this schema"

  field :user do
    type UserType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      User.find(args[:id])
    }
  end
end