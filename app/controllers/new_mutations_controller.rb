class MutationsController < ApplicationController

# new | clone | move | destroy
# current | current_only
# root | parent | current | child
# new: root | parent | current | child

# clone: current | current_only
# move: current | current_only

# clone_current_to: root | parent | current | child | cancel
# clone_current_only_to: root | parent | current | child | cancel

# move_current_to: root | parent | current | child | cancel
# move_current_only_to: root | parent | current | child | cancel

# destroy: current | current_only

  def index
    go_index
  end
  def show
    go_show
  end
  def new
    go_new
  end
  def create
    go_create
  end
  def update
    go_update
  end
  def destroy
    go_destroy
  end

  def new_root
    go_new_root
  end
  def new_parent
    go_new_parent
  end
  def new_current
    go_new_current
  end
  def new_child
    go_new_child
  end

  def set_clone_current
    go_set_clone_current
  end
  def set_clone_current_only
    go_set_clone_current_only
  end
  def set_move_current
    go_set_move_current
  end
  def set_move_current_only
    go_set_move_current_only
  end

  def cancel_clone_current
    go_cancel_clone_current
  end
  def cancel_clone_current_only
    go_cancel_clone_current_only
  end
  def cancel_move_current
    go_cancel_move_current
  end
  def cancel_move_current_only
    go_cancel_move_current_only
  end

  def clone_current_to_root
    go_clone_current_to_root
  end
  def clone_current_to_parent
    go_clone_current_to_parent
  end
  def clone_current_to_current
    go_clont_current_to_current
  end
  def clone_current_to_child
    go_clone_current_to_child
  end

  def clone_current_only_to_root
    go_clone_current_only_to_root
  end
  def clone_current_only_to_parent
    go_clone_current_only_to_parent
  end
  def clone_current_only_to_current
    go_clone_current_only_to_current
  end
  def clone_current_only_to_child
    go_clone_current_only_to_child
  end

  def move_current_to_root
    go_move_current_to_root
  end
  def move_current_to_parent
    go_move_current_to_parent
  end
  def move_current_to_current
    go_move_current_to_current
  end
  def move_current_to_child
    go_move_current_to_child
  end

  def move_current_only_to_root
    go_move_current_only_to_root
  end
  def move_current_only_to_parent
    go_move_current_only_to_parent
  end
  def move_current_only_to_current
    go_move_current_only_to_current
  end
  def move_current_only_to_child
    go_move_current_only_to_child
  end

  def destroy_current
    go_destroy_current
  end
  def destroy_current_only
    go_destroy_current_only
  end

#protected

  def go_index
    get_evolution_with_id_of_evolution params[:evolution_id]
    get_mutations_through_evolution
  end
  def go_show
    get_mutation_and_evolution_with_id_of_mutation
  end
  def go_new # new_mutation_or_new_child_mutation
    if is_new_mutation_a_child?
      if is_mutation_a_root? Mutation.find(params[:mutation_id])
	get_evolution_with_id_of_evolution mutation.evolution_id
      else # mutation is NOT root
	get_root_mutation_with_mutation mutation
	get_evolution_with_id_of_evolution @root_mutation.evolution_id
      end
      get_new_mutation
      set_mutation_parent_id params[:mutation_id]
    else # then new mutation is NOT a child
      get_evolution_with_id_of_evolution params[:evolution_id]
      get_new_mutation_through_evolution
      set_mutation_evolution_id params[:evolution_id]
    end
  end
  def go_create
    get_new_mutation_from_form_submission
    if @mutation.save
      flash[:notice] = "Creation Success"
      redirect_to @mutation
    else
      render :action => 'new'
    end
  end
  def go_update
    get_mutation_and_evolution_with_id_of_mutation
    if update_attributes_for_mutation
      flash[:notice] = "Update Success, Thank You"
      redirect_to @mutation
    else
      flash[:notice] = "Update Fail, Try Again"
      redirect_to @mutation
    end
  end
  def go_destroy
    get_mutation_and_evolution_with_id_of_mutation
    mutation_parent = mutation.ancestors.first # get mutation parent
    @mutation.destroy # destroy mutation
    if mutation_parent # if mutation parent exists
      flash[:notice] = "Destruction Success" # flash success
      redirect_to mutation_parent # redirect to parent
    else # then mutation evolution exists
      flash[:notice] = "Destruction Success" # flash success
      redirect_to evolution_mutations_path(:evolution_id => @evolution.id) # goto index
    end
  end


  def go_new_root
    mutation_current = Mutation.find(params[:id]) # get current
    mutation_super = Evolution.find(mutation_current.evolution_id) # get super
    mutation_root = mutation_current.ancestors.last # get root
    mutation_new = Mutation.new # get new
    mutation_new.evolution_id = mutation_super.id # attach new to super
    mutation_new.save # save new
    mutation_root.evolution_id = nil # detach root from super
    mutation_root.mutation_id = mutation_new.id # attach root to new
    mutation_root.save # save root
    flash[:notice] "Success, New Root Complete" # flash success, new root planted
    redirect_to mutation_new # redirect to new
  end
  def go_new_parent
    mutation_current = Mutation.find(params[:id]) # get current
    if mutation_current.mutation_id # if has parent?
      mutation_parent = Mutation.find(mutation_current.mutation.id # get parent
      mutation_current.mutation_id = nil # detach parent from current
      get_new_mutation # get new 
      @mutation.mutation_id = mutation_parent.id # attach new to parent
      if @mutation.save # save new
        status = "Success Creating New Parent"
      else
        status = "Failure Creating New Parent"
      end
      mutation_current.mutation_id = @mutation.id # attach current to new
      mutation_current.save # save current
    else # else has super_parent
      if mutation_current.evolution_id # if is root?
        mutation_super_parent = Evolution.find(mutation_current.evolution_id) # get super_parent
	mutation_current.evolution_id = nil # detach current from super_parent
        @mutation = Mutation.new # get new 
        @mutation.evolution_id = mutation_super_parent.id # attach new to super_parent
        if @mutation.save # save new
          status = "Success Creating New Parent"
        else
          status = "Failure Creating New Parent"
        end
        mutation_current.mutation_id = @mutation.id # attach current to new
        mutation_current.save # save current
      end
    end
    flash[:notice] = status # flash status
    redirect_to @mutation # redirect to new
  end
  def go_new_current
    mutation = Mutation.find(params[:id]) # get mutation
      if mutation.evolution_id # if mutation root
	get_evolution_with_id_of_evolution mutation.evolution_id
	get_new_mutation_through_evolution
      else # then mutation non_root
        get_new_mutation
	set_mutation_parent_id mutation.id 
      end 
    save_mutation
    flash[:notice] = "New Mutation Root Success, Thank You"
    redirect_to @mutation
  end
  def go_new_child
    get_new_mutation
    set_mutation_parent_id params[:id]
    save_mutation
    flash[:notice] = "New Mutation Child Success, Thank You"
    redirect_to @mutation
  end

  def go_set_clone_current
    mutation_current = Mutation.find(params[:id]) # get current
    session[:clone_current_id] = mutation_current.id # set clone current
    redirect_to @mutation # redirect to current
  end
  def go_set_clone_current_only
    mutation_current = Mutation.find(params[:id]) # get current
    session[:clone_current_only_id] = mutation_current.id # set clone current
    redirect_to mutation_current # redirect to current
  end
  def go_set_move_current
    mutation_current = Mutation.find(params[:id]) # get current
    session[:move_current_id] = mutation_current.id # set move current
    redirect_to mutation_current # redirect to current
  end
  def go_set_move_current_only
    mutation_current = Mutation.find(params[:id]) # get current
    session[:move_current_only_id] = mutation_current.id # set move current only
    redirect_to mutation_current # redirect to current
  end

  def go_cancel_clone_current
    session[:clone_current_id] = nil # cancel clone current
  end
  def go_cancel_clone_current_only
    session[:clone_current_only_id] = nil # cancel clone current
  end
  def go_cancel_move_current
    session[:move_current_id] = nil # cancel move current
  end
  def go_cancel_move_current_only
    session[:move_current_only_id] = nil # cancel move current only
  end

  def go_clone_current_to_root
    get_mutation_clone_current # then get mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current
    mutation_root = mutation_current.ancestors.last # get root
    @mutation_clone.evolution_id = mutation_root.evolution_id # attach clone to root super
    @mutation_clone.save # save clone
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_to_parent
    get_mutation_clone_current # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
      mutation_current.mutation_id = @mutation_clone.id # attach current to clone
      mutation_current.save # save current
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
        mutation_current.evolution_id = @mutation_clone.id # attach current to clone
        mutation_current.save # save current
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_to_current
    get_mutation_clone_current # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_to_child
    get_mutation_clone_current # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    @mutation_clone.mutation_id = mutation_current.id # attach clone to current 
    @mutation_clone.save # save clone
    if mutation_current.children.exists? # if current has children
      for mutation in mutation_current.children # attach children to clone
        mutation.mutation_id = @mutation_clone.id # attach child to clone
        mutation.save # save child
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end

# *** go_clone_current_only_to_

  def go_clone_current_only_to_root
    get_mutation_clone_current_only # get mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current
    mutation_root = mutation_current.ancestors.last # get root
    @mutation_clone.evolution_id = mutation_root.evolution_id # attach clone to root super
    @mutation_clone.save # save clone
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_only_to_parent
    get_mutation_clone_current_only # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
      mutation_current.mutation_id = @mutation_clone.id # attach current to clone
      mutation_current.save # save current
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
        mutation_current.evolution_id = @mutation_clone.id # attach current to clone
        mutation_current.save # save current
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_only_to_current
    get_mutation_clone_current_only # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_only_to_child
    get_mutation_clone_current_only # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    @mutation_clone.mutation_id = mutation_current.id # attach clone to current 
    @mutation_clone.save # save clone
    if mutation_current.children.exists? # if current has children
      for mutation in mutation_current.children # attach children to clone
        mutation.mutation_id = @mutation_clone.id # attach child to clone
        mutation.save # save child
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end

  def go_move_current_to_root
  end
  def go_move_current_to_parent
  end
  def go_move_current_to_current
  end
  def go_move_current_to_child
  end

  def go_move_current_only_to_root
  end
  def go_move_current_only_to_parent
  end
  def go_move_current_only_to_current
  end
  def go_move_current_only_to_child
  end

  def get_mutation_clone_current # clone session set_mutation_clone_current as @mutation_clone
    mutation_current = Mutation.find(session[:set_mutation_clone_current]) # get current
    @mutation_clone = Mutation.new # get new clone
    # copy current info to clone
    @mutation_clone.save # save clone
    then_go_clone_children mutation_current, @mutation_clone # clone children of current, to new parent end
  end

  def then_go_clone_children(pass_mutation, pass_mutation_clone)
    for mutation in pass_mutation.children # for each child of current children
      mutation_clone = Mutation.new # get new clone
      mutation_clone.mutation_id = pass_mutation_clone.id # attach clone to new
      # this is where you would copy child info to clone 
      mutation_clone.save # save clone
      then_go_clone_children mutation, mutation_clone # loop forever until done
    end
  end

  def get_mutation_clone_current_only # clone session set_mutation_clone_current_only as @mutation_clone
    mutation_current = Mutation.find(session[:set_mutation_clone_current_only]) # get current
    @mutation_clone = Mutation.new # get new clone
    # copy current info to clone
    @mutation_clone.save # save clone
  end

  def go_destroy_current
  end
  def go_destroy_current_only
  end

  # new

  def get_new_mutation
    @mutation = Mutation.new
  end
  def get_new_mutation_through_evolution
    @mutation = @evolution.mutations.new
  end
  def get_new_mutation_from_form_submission(mutation_params=params[:mutation])
    @mutation = Mutation.new(mutation_params)
  end
  
  def get_mutation_with_id_of_mutation(id_of_mutation)
    @mutation = Mutation.find(id_of_mutation) # get mutation
  end
  def get_evolution_with_id_of_evolution(id_of_evolution)
    @evolution = Evolution.find(id_of_evolution)
  end
  def get_mutations_through_evolution
    @mutations = @evolution.mutations.all
  end
  def get_mutation_through_evolution_with_id_of_mutation(id_of_mutation)
    @mutation = @evolution.mutations.find(id_of_mutation) # get mutation
  end
  def get_mutation_and_evolution_with_id_of_mutation
    mutation = Mutation.find(params[:id])
    if is_mutation_a_root?
      get_evolution_with_id_of_evolution mutation.evolution_id
      get_mutation_through_evolution_with_id_of_mutation params[:id]
    else
      root_mutation = mutation.ancestors.last # get root mutation
      get_evolution_with_id_of_evolution root_mutation.evolution_id
      get_mutation_with_id_of_mutation params[:id]
    end
  end
  def get_mutation_parent_with_id_of_mutation(id_of_mutation)
    mutation = Mutation.find(id_of_mutation)
    @mutation_parent = mutation.ancestors.first
  end

  def update_attributes_for_mutation
    @mutation.update_attributes(params[:mutation])
  end

  def is_mutation_a_root?(pass_mutation)
    if pass_mutation.evolution_id # if root then true
      true
    else
      false
    end
  end

  def get_root_mutation_with_mutation(mutation)
    @root_mutation = mutation.ancestors.last
  end

  def set_mutation_parent_id(id_of_parent_mutation)
    @mutation.mutation_id = id_of_parent_mutation
  end
  def set_mutation_evolution_id(id_of_evolution)
    @mutation.evolution_id = id_of_evolution
  end
  
  def is_new_mutation_a_child?
    if params[:mutation_id]
      true
    else
      false
    end
  end

  def save_mutation
    @mutation.save
  end
  
end
