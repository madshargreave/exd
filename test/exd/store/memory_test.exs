defmodule Exd.Store.MemoryTest do
  use ExUnit.Case
  alias Exd.Store.Memory, as: MemoryStore

  describe "start_link/1" do
    test "it starts store" do
      assert {:ok, _} = MemoryStore.start_link(name: :my_store)
    end
  end

  describe "all/1" do
    test "it lists all entries in store" do
      {:ok, _} = MemoryStore.start_link(name: :my_store)
      assert {:ok, []} = MemoryStore.all(:my_store)
      assert :ok = MemoryStore.put(:my_store, 1, %{message: "hello"})
      assert {:ok, [%{message: "hello"}]} == MemoryStore.all(:my_store)
    end
  end

  describe "get/2" do
    test "it retrives entry with key" do
      {:ok, _} = MemoryStore.start_link(name: :my_store)
      :ok = MemoryStore.put(:my_store, 1, %{message: "hello"})
      assert {:ok, %{message: "hello"}} == MemoryStore.get(:my_store, 1)
    end

    test "it returns `:not_found` if no match is found" do
      {:ok, _} = MemoryStore.start_link(name: :my_store)
      assert :not_found == MemoryStore.get(:my_store, 1)
    end
  end

  describe "put/3" do
    test "it inserts values into store" do
      {:ok, _} = MemoryStore.start_link(name: :my_store)
      {:ok, []} = MemoryStore.all(:my_store)
      assert :ok = MemoryStore.put(:my_store, 1, %{message: "hello"})
      assert {:ok, %{message: "hello"}} == MemoryStore.get(:my_store, 1)
    end

    test "it overrides previous values with same key" do
      {:ok, _} = MemoryStore.start_link(name: :my_store)
      {:ok, []} = MemoryStore.all(:my_store)
      :ok = MemoryStore.put(:my_store, 1, %{message: "hello"})
      assert {:ok, %{message: "hello"}} == MemoryStore.get(:my_store, 1)
      :ok = MemoryStore.put(:my_store, 1, %{message: "goodbye"})
      assert {:ok, %{message: "goodbye"}} == MemoryStore.get(:my_store, 1)
    end
  end

end
