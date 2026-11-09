require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def create_interviewer(name, tags: [])
    user = User.create!(email: "#{name}@example.com", password: "password", username: name, first_name: name.capitalize,
                        interviewer: true, years_experience: 4, headline: "Developer",
                        about: "I enjoy helping people prepare.")
    # Added after create, like the app does: UserTag validates user_id presence.
    user.update!(tag_ids: tags.map(&:id))
    user
  end

  test "the interviewer list shows each interviewer's tags" do
    get users_path

    assert_response :success
    assert_match "Alice", response.body
    assert_match "RoR", response.body
  end

  # Guards against the N+1 coming back: with tags and photos preloaded, more
  # interviewers must not mean more queries.
  test "the interviewer list runs the same number of queries however many cards it shows" do
    get users_path # warm up: asset compilation and schema cache
    baseline = count_queries { get users_path }

    3.times { |i| create_interviewer("extra#{i}", tags: [tags(:ruby), tags(:css)]) }

    assert_equal baseline, count_queries { get users_path }
  end

  test "filtering by two tags lists a matching interviewer once" do
    get users_path, params: { tags: "Ruby,RoR" }, headers: { "Accept" => "text/plain" }

    assert_equal 1, response.body.scan("@alice").size
  end

  test "filtering keeps all of an interviewer's tags on their card" do
    get users_path, params: { tags: "Ruby" }, headers: { "Accept" => "text/plain" }

    assert_match "RoR", response.body
  end

  test "cards show at most 4 tags, then a +N pill" do
    user = users(:alice)
    Tag.find_each { |tag| UserTag.find_or_create_by!(user: user, tag: tag) }

    get users_path

    assert_select ".user-card-tags .individual-tag", 5 # 4 tags + the "+1" pill
    assert_select ".individual-tag p", text: "+1"
  end
end
