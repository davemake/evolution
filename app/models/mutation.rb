class Mutation < ActiveRecord::Base
  #attr_accessible :mutation_id, :evolution_id
  acts_as_tree :foreign_key => 'mutation_id', :dependent => :destroy
  belongs_to :evolution
end
