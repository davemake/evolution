class EvolutionsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# Evolution: Tree | New | Clone | Move | Destroy # layouts/evolutions/menu
#
# New: Root | Parent | Current | Child # layouts/mutatons/new
# Clone Current: Complete | One # layouts/evolutions/clone
# Move Current: Complete | One # layouts/evolutions/move
# Destroy Current: Complete | One # layouts/evolutions/destroy
#
# Clone to: Root | Parent | Current | Child | Cancel # layouts/evolutions/clone_to
# Clone uni to: Root | Parent | Current | Child | Cancel # layouts/evolutions/clone_uni_to
# Move to: Root | Parent | Current | Child | Cancel # layouts/evolutions/move_to
# Move uni to: Root | Parent | Current | Child | Cancel # layouts/evolutions/move_uni_to
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 ***basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def index
    @evolutions = Evolution.all
  end
  
  def show
    get_evolutions
  end
   
  def new
    @no_links = true
    @evolution = Evolution.new
    @evolution.evolution_id = params[:evolution_id]
  end
  
  def create
    @evolution = Evolution.new(params[:evolution])
    if @evolution.save
      flash[:notice] = "Successfully created evolution."
      redirect_to @evolution
    else
      render :action => 'new'
    end
  end
  
  def edit
    @evolution = Evolution.find(params[:id])
  end
  
  def update
    @evolution = Evolution.find(params[:id])
    if @evolution.update_attributes(params[:evolution])
      flash[:notice] = "Successfully updated evolution."
      redirect_to @evolution
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @evolution = Evolution.find(params[:id])
    @evolution.destroy
    flash[:notice] = "Successfully destroyed evolution."
    redirect_to evolutions_url
  end




# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   ***save 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_new
    if @evolution_new.save
      flash_success
      redirect_to @evolution_new
    else
      flash_fail
      redirect_to @evolution
    end
  end

  def save_clone
    if @evolution_clone.save
      flash_success
      session[:evolution_clone_id] = nil
      redirect_to @evolution_clone
    else
      flash_fail
      redirect_to @evolution
    end
  end
  def save_clone_uni
    if @evolution_clone_uni.save
      flash_success
      session[:evolution_clone_uni_id] = nil
      redirect_to @evolution_clone_uni
    else
      flash_fail
      redirect_to @evolution
    end
  end

  def save_move
    if @evolution_move.save
      flash_success
      session[:evolution_move_id] = nil
      redirect_to @evolution_move
    else
      flash_fail
      redirect_to @evolution
    end
  end
  def save_move_uni
    if @evolution_move_uni.save
      flash_success
      session[:evolution_move_uni_id] = nil
      redirect_to @evolution_move_uni
    else
      flash_fail
      redirect_to @evolution
    end
  end
  

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   ***new
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def new_root
    get_evolutions
    @evolution_new = Evolution.new
    place_at_root @evolution_new
    save_new
  end
  def new_parent
    get_evolutions
    @evolution_new = Evolution.new
    place_at_parent @evolution_new
    save_new
  end
  def new_current
    get_evolutions
    @evolution_new = Evolution.new
    place_at_current @evolution_new
    save_new
  end
  def new_children
    get_evolutions
    @evolution_new = Evolution.new
    @evolution_new.save
    place_at_children @evolution_new
    save_new
  end
  def new_child
    get_evolutions
    @evolution_new = Evolution.new
    place_at_child @evolution_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   ***set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone
    get_evolutions
    session[:evolution_clone_id] = @evolution.id # set clone
    redirect_to @evolution # redirect to current
  end
  def set_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id] = @evolution.id # set clone uni
    redirect_to @evolution # redirect to current
  end
  def set_move
    get_evolutions
    session[:evolution_move_id] = @evolution.id # set move
    redirect_to @evolution # redirect to current
  end
  def set_move_uni
    get_evolutions
    session[:evolution_move_uni_id] = @evolution.id # set move uni
    redirect_to @evolution # redirect to current
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  ***cancel
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def cancel_clone
    get_evolutions
    session[:evolution_clone_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end
  def cancel_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end
  def cancel_move
    get_evolutions
    session[:evolution_move_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end
  def cancel_move_uni
    get_evolutions
    session[:evolution_move_uni_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  ***clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def copy_over(pass1, pass2)
    #...
  end
  def clone_children(pass1, pass2)
    pass1.children.each do |evolution|
      evolution_new = Evolution.new
      copy_over evolution, evolution_new
      evolution_new.save
      attach_to evolution_new, pass2
      clone_children evolution, evolution_new
    end
  end

  def make_clone
    get_evolutions
    evolution_new = Evolution.new
    evolution_new.save
    copy_over @evolution_clone, evolution_new
    clone_children @evolution_clone, evolution_new
    @evolution_clone = evolution_new
  end
  def make_clone_uni
    get_evolutions
    evolution_clone_uni = Evolution.new
    copy_over evolution_clone_uni, @evolution_clone_uni
    @evolution_clone_uni = evolution_clone_uni
  end

  def clone_to_root
    make_clone
    place_at_root @evolution_clone
    save_clone
  end
  def clone_to_parent
    make_clone
    place_at_parent @evolution_clone
    save_clone
  end
  def clone_to_current
    make_clone
    place_at_current @evolution_clone
    save_clone
  end
  def clone_to_children
    make_clone
    place_at_children @evolution_clone
    save_clone
  end
  def clone_to_child
    make_clone
    place_at_child @evolution_clone
    save_clone
  end
  
  def clone_uni_to_root
    make_clone_uni
    place_at_root @evolution_clone_uni
    save_clone_uni
  end
  def clone_uni_to_parent
    make_clone_uni
    place_at_parent @evolution_clone_uni
    save_clone_uni
  end
  def clone_uni_to_current
    make_clone_uni
    place_at_current @evolution_clone_uni
    save_clone_uni
  end
  def clone_to_child
    make_clone
    place_at_child @evolution_clone
    save_clone
  end
  def clone_uni_to_children
    make_clone_uni
    place_at_children @evolution_clone_uni
    save_clone_uni
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   *move
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def childship(pass1, pass2) # check for childship
    @not_child_or_current = true # childship true
    if pass1 == pass2 # if one equals two
      @not_child_or_current = false # childship false
    else
      childship_children pass1, pass2 # check children
    end
  end
  def childship_children(pass1, pass2)
    pass1.children.each do |child|
      if child == pass2
        @not_child_or_current = false
      end
      childship_children child, pass2
    end
  end
    
  def move_to_root
    get_evolutions
    place_at_root @evolution_move
    save_move
  end
  def move_to_parent
    get_evolutions
    place_at_parent @evolution_move
    save_move
  end
  def move_to_current
    get_evolutions
    place_at_current @evolution_move
    save_move
  end
  def move_to_children
    get_evolutions
    place_at_children @evolution_move
    save_move
  end
  def move_to_child
    get_evolutions # get evolutions
    place_at_child @evolution_move # place move at child position
    save_move # save move
  end

  def move_children_to(pass)
    @evolution.children.each do |child| # for children
      attach_to child, pass # attach child to pass
    end # end
  end

  def move_uni_to_root
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_root @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_parent
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_parent @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_current
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_current @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_child @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_children @evolution_move_uni
    save_move_uni
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 ***destroy
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def destroy_current
    get_evolutions
    if @evolution.destroy
      flash_success
      if @evolution_parent
        redirect_to @evolution_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @evolution
    end
  end
  def destroy_current_uni
    get_evolutions
    distill_evolution @evolution
    if @evolution.destroy
      flash_success
      if @evolution_parent
        redirect_to @evolution_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @evolution
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 ***place 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(pass)
    #pass.evolution_id = @evolution_root.evolution_id
    pass.evolution_id = nil
    pass.save
  end
  def place_at_parent(pass)
    if @evolution_parent # if parent
      attach_to pass, @evolution_parent # attach pass to parent
      pass.save # save pass
    else # else, root
      pass.evolution_id = nil # erase parent
      pass.save # save pass
    end # end
    attach_to @evolution, pass # attach evolution to pass
    @evolution.save # save evolution to new parent
  end
  def place_at_current(pass)
    if @evolution_parent # if parent 
      attach_to pass, @evolution_parent # attach pass to parent
    else # else, is root
      pass.evolution_id = nil # erase parent
    end # end 
    pass.save # save pass
  end
  def place_at_child(pass)
    attach_to pass, @evolution
    pass.save
  end
  def place_at_children(pass)
    move_children_to pass
    place_at_child pass
    pass.save
  end

# pass1 = the evolution that will be re-assigned
# pass2 = the evolution that will remain un-changed
# whole = indicates if the pass1 includes all children

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 ***distill 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def distill_evolution(pass1)
    if pass1.evolution_id # if pass1 has parent
      pass1_parent = Evolution.find(pass1.evolution_id)
      attach_children_to pass1, pass1_parent
    else # pass1 has super
      pass1_super = Evolution.find(pass1.evolution_id)
      attach_children_to pass1, pass1_super, true
    end
    pass1.evolution_id = pass1.evolution_id = nil
    pass1.save
  end
  
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  ***attach 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def attach_to(pass1, pass2, pass2_is_super=false)
    if pass2_is_super
      pass1.evolution_id = nil
      pass1.evolution_id = pass2.id
      pass1.save
    else # pass2 is parent
      pass1.evolution_id = pass2.id
      #pass1.evolution_id = nil
      pass1.save
    end
  end

  def attach_children_to(pass1, pass2)
    for evolution in pass1.children # attach children to pass
      attach_to evolution, pass2 
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  ***flash 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def flash_success
    flash[:notice] = "Success" # flash success
  end
  def flash_fail
    flash[:error] = "Fail, try again" # flash fail
  end

 
  def start
    @evolution = Evolution.find(params[:id])
    @evolution.start_time = Time.now
    if @evolution.save
      flash[:notice] = "Successfully started evolution(#{@evolution.id}) at #{@evolution.start_time}"
      redirect_to @evolution
    else
      flash[:error] = "Sorry, try again."
      redirect_to @evolution
    end
  end 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                              ***get_evolutions 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 


# get_evolutions
## @evolution_super(if exists)
# @evolution_root
# @evolution_parent(if exists)
# @evolution
# @evolution_move(if exists)
# @evolution_move_uni(if exists)
# @evolution_clone(if exists)
# @evolution_clone_uni(if exists)

  def get_evolutions(pass=params[:id])
    @evolution = Evolution.find(pass) # get current
    @evolution_root = @evolution.ancestors.last # get root
    #if @evolution.evolution_id
      #@evolution_super = Evolution.find(@evolution.evolution_id)
    #end # get super of current
    if @evolution.evolution_id
      @evolution_parent = Evolution.find(@evolution.evolution_id)
    end # get parent of current
    if session[:evolution_clone_id]
      @evolution_clone = Evolution.find(session[:evolution_clone_id]) 
    end # get clone_current from session
    if session[:evolution_clone_uni_id]
      @evolution_clone_uni = Evolution.find(session[:evolution_clone_uni_id]) 
    end # get clone_current_uni from session
    if session[:evolution_move_id]
      @evolution_move = Evolution.find(session[:evolution_move_id]) 
      if @evolution # if current
        childship @evolution_move, @evolution # check for childship
      end # end
    end # get move_current from session
    if session[:evolution_move_uni_id]
      @evolution_move_uni = Evolution.find(session[:evolution_move_uni_id]) 
      if @evolution # if current
        childship @evolution_move_uni, @evolution # check for childship
      end # end
    end
  end



end
