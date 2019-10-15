# frozen_string_literal: true

require 'spec_helper'

describe Warden::JWTAuth::HeaderParser do
  describe '#from_env(env)' do
    context 'when authorization method is Bearer' do
      it 'returns token' do
        env = { 'HTTP_X_AUTHORIZATION' => 'Bearer 123' }

        expect(described_class.from_env(env)).to eq('123')
      end
    end

    context 'when authorization method is something else' do
      it 'returns nil' do
        env = { 'HTTP_X_AUTHORIZATION' => 'Basic 123' }

        expect(described_class.from_env(env)).to be_nil
      end
    end

    context 'when there is no authorization method' do
      it 'returns nil' do
        env = { 'HTTP_X_AUTHORIZATION' => '123' }

        expect(described_class.from_env(env)).to be_nil
      end
    end

    context 'when there is no X-Authorization header' do
      it 'returns nil' do
        env = {}

        expect(described_class.from_env(env)).to be_nil
      end
    end
  end

  describe '#to_env(env, token)' do
    it 'returns a copy of env with token added in X-Authorization header' do
      env = {}

      env = described_class.to_env(env, '123')

      expect(env).to eq('HTTP_X_AUTHORIZATION' => 'Bearer 123')
    end
  end

  describe '#to_headers(headers, token)' do
    it 'returns a copy of headers with token added to X-Authorization key' do
      headers = {}

      headers = described_class.to_headers(headers, '123')

      expect(headers).to eq('X-Authorization' => 'Bearer 123')
    end
  end
end
