class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:edit, :update]

  def index
    @pages = Page.order(:slug)
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: 'Page content updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page
    @page = Page.find_by!(slug: params[:slug])
  end

  def page_params
    params.require(:page).permit(:title, :content)
  end
end
