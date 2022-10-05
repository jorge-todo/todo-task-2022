require 'rails_helper'

describe Api::V1::ItemsController, type: :request do
  describe "GET api/v1/tasks" do

    context "when there are not tasks" do
      before { get "api/v1/tasks", params: {}, xhr: true }

      it "returns tasks" do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).size).to eq(0)
      end
    end

    context "when there are tasks" do
      before do
        5.times.each {|_n| create(:item) }
        get "api/v1/tasks", params: {}, xhr: true
      end

      it "returns tasks" do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe "GET api/v1/task" do

    context "when the task doesn't exist" do
      before { get "api/v1/task", params: { id: 169 }, xhr: true }

      it "returns tasks" do
        expect(response.status).to eq(404)
        expect(response.body).to eq("Task not found.")
      end
    end

    context "when the task exists" do
      let(:date) { Date.today }
      let!(:item) { create(:item, description: "Description", due_date: date, priority: 1) }

      before { get "api/v1/task", params: { id: item.id }, xhr: true }

      it "returns the correct task" do
        expect(response.status).to eq(200)
        data = JSON.parse(response.body).symbolize_keys
        expect(data[:id]).to eq(item.id)
        expect(data[:title]).to eq(item.title)
        expect(data[:description]).to eq(item.description)
        expect(data[:due_date]).to eq(date.to_s)
        expect(data[:priority]).to eq(item.priority)
      end
    end
  end

  describe "POST api/v1/task" do
    context "when the task doesn't exist" do
      before { post "api/v1/task", params: { id: 169 }, xhr: true }

      it "returns error message" do
        expect(response.status).to eq(404)
        expect(response.body).to eq("Task not found.")
      end
    end

    context "when updating title to blank" do
      let!(:item) { create(:item) }
      let(:params) { {id: item.id, title: ""} }

      before { post "api/v1/task", params: params, xhr: true }

      it "returns error message" do
        expect(response.status).to eq(422)
        expect(response.body).to eq("Title can't be blank")
      end
    end

    context "when the task exists" do
      let(:tomorrow) { Date.tomorrow }
      let!(:item) { create(:item, description: "Description", due_date: Date.today, priority: 1) }
      let(:params) { {id: item.id, title: "New Title", description: "Other description", due_date: tomorrow, priority: 3} }

      before { post "api/v1/task", params: params, xhr: true }

      it "updates task correctly" do
        expect(response.status).to eq(200)
        data = JSON.parse(response.body).symbolize_keys
        params.each_key { |attribute| data[attribute] = params[attribute]}
      end
    end
  end

  describe "POST api/v1/new-task" do
    context "when creating with blank title" do

      before { post "api/v1/new-task", params: { title: "" }, xhr: true }

      it "returns error message" do
        expect(response.status).to eq(422)
        expect(response.body).to eq("Title can't be blank")
        expect(Item.count).to eq(0)
      end
    end

    context "when correct params" do
      let(:date) { Date.today }
      let(:params) { {title: "My Title", description: "Other description", due_date: date, priority: 1} }

      before { post "api/v1/new-task", params: params, xhr: true }

      it "creates the new task" do
        expect(response.status).to eq(200)
        data = JSON.parse(response.body).symbolize_keys
        params.each_key { |attribute| data[attribute] = params[attribute]}
        expect(Item.count).to eq(1)
      end
    end
  end
end